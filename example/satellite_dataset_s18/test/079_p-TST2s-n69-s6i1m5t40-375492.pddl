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
	satellite5 - satellite
	instrument5 - instrument
	thermograph4 - mode
	infrared0 - mode
	image2 - mode
	infrared1 - mode
	infrared3 - mode
	Star0 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	Star10 - direction
	Star12 - direction
	Star13 - direction
	GroundStation21 - direction
	GroundStation23 - direction
	GroundStation24 - direction
	GroundStation25 - direction
	Star27 - direction
	GroundStation29 - direction
	Star35 - direction
	GroundStation36 - direction
	GroundStation8 - direction
	Star31 - direction
	Star33 - direction
	GroundStation4 - direction
	GroundStation19 - direction
	Star26 - direction
	GroundStation14 - direction
	GroundStation20 - direction
	Star15 - direction
	GroundStation17 - direction
	GroundStation3 - direction
	Star39 - direction
	Star16 - direction
	Star28 - direction
	Star30 - direction
	Star38 - direction
	Star2 - direction
	Star32 - direction
	Star37 - direction
	Star11 - direction
	GroundStation22 - direction
	GroundStation34 - direction
	Star1 - direction
	GroundStation18 - direction
	Planet40 - direction
	Planet41 - direction
	Star42 - direction
	Phenomenon43 - direction
	Planet44 - direction
	Phenomenon45 - direction
	Phenomenon46 - direction
	Planet47 - direction
	Planet48 - direction
	Star49 - direction
	Star50 - direction
	Star51 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 image2)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 Star26)
	(calibration_target instrument0 GroundStation8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star35)
	(supports instrument1 image2)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 Star31)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star42)
	(supports instrument2 image2)
	(supports instrument2 infrared1)
	(supports instrument2 thermograph4)
	(calibration_target instrument2 Star28)
	(calibration_target instrument2 GroundStation14)
	(calibration_target instrument2 Star26)
	(calibration_target instrument2 GroundStation19)
	(calibration_target instrument2 GroundStation22)
	(calibration_target instrument2 Star16)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 Star33)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation3)
	(supports instrument3 image2)
	(supports instrument3 thermograph4)
	(calibration_target instrument3 Star39)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 GroundStation17)
	(calibration_target instrument3 Star15)
	(calibration_target instrument3 GroundStation20)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation7)
	(supports instrument4 infrared0)
	(calibration_target instrument4 Star37)
	(calibration_target instrument4 Star32)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 Star38)
	(calibration_target instrument4 Star30)
	(calibration_target instrument4 Star28)
	(calibration_target instrument4 Star16)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star33)
	(supports instrument5 infrared0)
	(supports instrument5 image2)
	(supports instrument5 thermograph4)
	(calibration_target instrument5 GroundStation18)
	(calibration_target instrument5 Star1)
	(calibration_target instrument5 GroundStation34)
	(calibration_target instrument5 GroundStation22)
	(calibration_target instrument5 Star11)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation23)
)
(:goal (and
	(pointing satellite1 Star30)
	(pointing satellite3 Star0)
	(pointing satellite4 GroundStation3)
	(have_image Planet40 infrared3)
	(have_image Planet41 infrared3)
	(have_image Star42 infrared3)
	(have_image Phenomenon43 thermograph4)
	(have_image Planet44 infrared0)
	(have_image Phenomenon45 infrared0)
	(have_image Phenomenon46 image2)
	(have_image Planet47 infrared0)
	(have_image Planet48 infrared3)
	(have_image Star49 infrared3)
	(have_image Star50 thermograph4)
	(have_image Star51 infrared0)
))

)
