(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	infrared1 - mode
	spectrograph0 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	Star14 - direction
	GroundStation15 - direction
	Star18 - direction
	Star20 - direction
	GroundStation21 - direction
	GroundStation22 - direction
	GroundStation23 - direction
	GroundStation26 - direction
	Star27 - direction
	Star28 - direction
	Star29 - direction
	GroundStation31 - direction
	Star32 - direction
	GroundStation33 - direction
	GroundStation36 - direction
	GroundStation38 - direction
	Star39 - direction
	GroundStation43 - direction
	GroundStation45 - direction
	Star9 - direction
	GroundStation44 - direction
	Star16 - direction
	Star40 - direction
	Star37 - direction
	GroundStation41 - direction
	Star42 - direction
	Star19 - direction
	GroundStation35 - direction
	Star25 - direction
	GroundStation30 - direction
	Star17 - direction
	GroundStation8 - direction
	Star24 - direction
	Star34 - direction
	Planet46 - direction
	Planet47 - direction
	Star48 - direction
	Planet49 - direction
	Star50 - direction
	Star51 - direction
	Star52 - direction
	Phenomenon53 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star16)
	(calibration_target instrument0 GroundStation41)
	(calibration_target instrument0 Star42)
	(calibration_target instrument0 GroundStation44)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation35)
	(supports instrument1 infrared1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star34)
	(calibration_target instrument1 Star24)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 Star17)
	(calibration_target instrument1 GroundStation30)
	(calibration_target instrument1 Star25)
	(calibration_target instrument1 GroundStation35)
	(calibration_target instrument1 Star19)
	(calibration_target instrument1 Star42)
	(calibration_target instrument1 GroundStation41)
	(calibration_target instrument1 Star37)
	(calibration_target instrument1 Star40)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star19)
)
(:goal (and
	(pointing satellite1 Star18)
	(have_image Planet46 spectrograph0)
	(have_image Planet47 spectrograph0)
	(have_image Star48 infrared1)
	(have_image Planet49 infrared1)
	(have_image Star50 infrared1)
	(have_image Star51 spectrograph0)
	(have_image Star52 spectrograph0)
	(have_image Phenomenon53 infrared1)
))

)
