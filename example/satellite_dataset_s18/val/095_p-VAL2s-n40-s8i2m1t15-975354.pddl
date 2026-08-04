(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	instrument5 - instrument
	satellite5 - satellite
	instrument6 - instrument
	instrument7 - instrument
	satellite6 - satellite
	instrument8 - instrument
	satellite7 - satellite
	instrument9 - instrument
	instrument10 - instrument
	spectrograph0 - mode
	Star1 - direction
	GroundStation14 - direction
	GroundStation6 - direction
	GroundStation10 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation7 - direction
	Star2 - direction
	Star12 - direction
	GroundStation5 - direction
	Star11 - direction
	Star9 - direction
	GroundStation8 - direction
	Star13 - direction
	Star0 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
	Phenomenon18 - direction
	Planet19 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation14)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation6)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation10)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation14)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 Star11)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star17)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star12)
	(calibration_target instrument3 Star2)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation14)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 Star4)
	(calibration_target instrument4 GroundStation5)
	(calibration_target instrument4 GroundStation6)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 GroundStation3)
	(calibration_target instrument5 Star13)
	(calibration_target instrument5 GroundStation7)
	(calibration_target instrument5 Star2)
	(calibration_target instrument5 Star4)
	(on_board instrument4 satellite4)
	(on_board instrument5 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star16)
	(supports instrument6 spectrograph0)
	(calibration_target instrument6 GroundStation7)
	(calibration_target instrument6 Star4)
	(supports instrument7 spectrograph0)
	(calibration_target instrument7 Star13)
	(calibration_target instrument7 Star12)
	(calibration_target instrument7 Star2)
	(on_board instrument6 satellite5)
	(on_board instrument7 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star0)
	(supports instrument8 spectrograph0)
	(calibration_target instrument8 Star11)
	(calibration_target instrument8 GroundStation5)
	(calibration_target instrument8 Star0)
	(on_board instrument8 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Phenomenon15)
	(supports instrument9 spectrograph0)
	(calibration_target instrument9 Star13)
	(calibration_target instrument9 GroundStation8)
	(calibration_target instrument9 Star9)
	(supports instrument10 spectrograph0)
	(calibration_target instrument10 Star0)
	(on_board instrument9 satellite7)
	(on_board instrument10 satellite7)
	(power_avail satellite7)
	(pointing satellite7 GroundStation6)
)
(:goal (and
	(pointing satellite0 Phenomenon15)
	(pointing satellite1 GroundStation3)
	(pointing satellite2 GroundStation10)
	(pointing satellite6 GroundStation14)
	(have_image Phenomenon15 spectrograph0)
	(have_image Star16 spectrograph0)
	(have_image Star17 spectrograph0)
	(have_image Phenomenon18 spectrograph0)
	(have_image Planet19 spectrograph0)
))

)
